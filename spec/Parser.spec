require 'rspec'
require './Parser/Parser.rb'
require './Parser/LaboratoryTestResult.rb'

describe Parser do
    parser = Parser.new('./test1.txt')

    describe 'mapped_results' do

        let(:data){double}
        let(:code) { "A250" }
        let(:result) { "result" }
        let(:format) { "format" }
        let(:comment) { ["Comment for NEGATIVE result"] }
        
        before do
            allow_any_instance_of(Parser).to receive(:initialize)
            allow(parser).to receive(:parse_result).with(any_args).and_return(result)
            allow(parser).to receive(:parse_format).with(any_args).and_return(format)
            allow(parser).to receive(:parse_comment).with(any_args).and_return(comment)
        end

        it 'returns laboratory_test_results' do
   
            expect(parser.mapped_results).not_to be(nil)
            expect(parser.mapped_results).to all be_an_instance_of(LaboratoryTestResult)
        end
    end

    describe '#numeric?' do
    
        context 'when numeric value is passed ' do
            let(:val) {12.0}
            it 'returns true' do
                expect(parser.send(:numeric?, val)).to eq(true)
            end
        end

        context 'when non numeric value is passed' do
            let(:val) {'test'}
            it 'returns false' do
                expect(parser.send(:numeric?, val)).to eq(false)
            end

        end
        
    end

    describe '#parse_format' do

        context 'when C100 code is passsed' do
            let(:code) {'C100'}
            it 'returns Float String' do
                expect(parser.send(:parse_format, code)).to eq('float')
            end
        end

        context 'when A250 code passed' do
            let(:code) {'A250'}
            it 'returns boolean String' do
                expect(parser.send(:parse_format, code)).to eq('boolean')
            end
        end

        context 'when B250 is passed' do
            let(:code) {'B250'}
            it 'returns nil_3plus' do
                expect(parser.send(:parse_format, code)).to eq('nil_3plus')
            end
        end

    end

    describe '#parse_result' do

        context 'when numeric value is passed' do
            let(:val){'20'}
            before do
                allow(parser).to receive(:numeric?).with(any_args).and_return(true)
            end
            it 'returns boolean of numeric value' do
                expect(parser.send(:parse_result, val)).to eq(20.0)
            end
        end

        context 'when NEGATIVE or NIL value is passed' do
            let(:val1){'NEGATIVE'}
            let(:val2){'NIL'}
            before do
                allow(parser).to receive(:numeric?).with(any_args).and_return(false)
            end
            it 'returns -1.0' do
                expect(parser.send(:parse_result, val1)).to eq(-1.0)
                expect(parser.send(:parse_result, val2)).to eq(-1.0)
            end
        end

        context 'when POSITIVE, + or ++ value is passed' do
            let(:val1){'POSITIVE'}
            let(:val2){'+'}
            let(:val3){'++'}
            before do
                allow(parser).to receive(:numeric?).with(any_args).and_return(false)
            end
            it 'returns -2.0' do
                expect(parser.send(:parse_result, val1)).to eq(-2.0)
                expect(parser.send(:parse_result, val2)).to eq(-2.0)
                expect(parser.send(:parse_result, val3)).to eq(-2.0)
            end
        end

        context 'when +++ is passed' do
            let(:val){'+++'}
            before do
                allow(parser).to receive(:numeric?).with(any_args).and_return(false)
            end
            it 'returns -3.0' do
                expect(parser.send(:parse_result, val)).to eq(-3.0)
            end
        end
    end

    describe '#parse_comments' do
        context 'when NTE is passed' do
            let(:val) do
                "NTE|4|Comment for some test result"
            end
            let(:expected_result){['Comment for some test result']}
            before do
                allow(val).to receive(:keep_if).with(any_args).and_return(expected_result)
            end
            it 'returns array containing the comment' do
                expect(parser.send(:parse_comments, val)).to eq(expected_result)
            end
        end

        context 'when keyword comment is not passed' do
            let(:val){'keyword missing for this test result'}
            let(:expected_result){[]}
            before do
                allow(val).to receive(:keep_if).with(any_args).and_return(expected_result)
            end
            it 'returns array containing the comment' do
                expect(parser.send(:parse_comments, val)).to eq(expected_result)
            end
        end

    end
    

end


