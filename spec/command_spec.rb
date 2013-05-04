require 'spec_helper'

describe TestBed::Command do

  describe '.command_for' do
    context 'When the command exists' do
      it 'returns that command class' do
        expect(TestBed::Command.command_for('ls')).to eq(TestBed::Command::List)
      end
    end

    context 'When the command does not exist yet' do
      it 'returns that help command class' do
        expect(TestBed::Command.command_for('foo')).to eq(TestBed::Command::Help)
      end
    end
  end

  describe '.run' do
    pending
  end
end

