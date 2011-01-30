require 'drb'

module ViewServer
  def view_as_attachement(file_extension)
    str = STDIN.read
    DRb.start_service
    obj = DRbObject.new(nil, "druby://localhost:10021")
    obj.affiche(file_extension, str)
    nil
  end
end
