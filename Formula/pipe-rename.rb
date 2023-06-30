class PipeRename < Formula
  desc "Rename your files using your favorite text editor"
  homepage "https://github.com/marcusbuffett/pipe-rename"
  url "https://ghproxy.com/https://github.com/marcusbuffett/pipe-rename/archive/refs/tags/1.6.5.tar.gz"
  sha256 "a11c13d14a4b4accf7f54b3b38f367404e85f33854d521d613de0b4b127bcc9d"
  license "MIT"
  head "https://github.com/marcusbuffett/pipe-rename.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5247b5abb2db537f642bc86af78ce14ae604f12ad8f5e876179ff3416b5ff75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dff7cbdfa50fd5fad647e8491c06134f9d1e0a62f0afec8b0be76a0019082c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "581bfd0d1b0fd38ba6d6147592b6a9b7b85c308644f1b2fa976fee1b020423e0"
    sha256 cellar: :any_skip_relocation, ventura:        "66632fc318f781c8296a93005f295ab578c3706b8b30cda2a455af3817af2ac9"
    sha256 cellar: :any_skip_relocation, monterey:       "401dc70c9559dcd16e9cd43a8daa141eb023c0e3eecba2d5760d420779ab1d7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6741c067c4749753e43d833c0b4e70fe2823039f342a5f63accd3a769898376b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cb490a7246f1f4bc720157a70df52ae56266aa2e3e88a9fc7a407689d0c37b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.log"
    (testpath/"rename.sh").write "#!/bin/sh\necho \"$(cat \"$1\").txt\" > \"$1\""
    chmod "+x", testpath/"rename.sh"
    ENV["EDITOR"] = testpath/"rename.sh"
    system "#{bin}/renamer", "-y", "test.log"
    assert_predicate testpath/"test.log.txt", :exist?
  end
end