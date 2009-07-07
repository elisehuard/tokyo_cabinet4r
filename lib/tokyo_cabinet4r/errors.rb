module TokyoCabinet4r
  class TCKeyNotFound < StandardError
  end

  class TCdbIssue < StandardError
  end

  class TCBDBIssue < StandardError
  end 

  class TCPutError < StandardError
  end

  class UnknownType < StandardError
  end

  class FileNotOpened < StandardError
  end 
end