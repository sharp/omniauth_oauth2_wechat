module M
  class<< self
    def test
      puts self.methods#"Which?"
    end
  end
end
puts M.test
puts M.object_id
