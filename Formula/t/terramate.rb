class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.6.3.tar.gz"
  sha256 "597f615652d9e94b219479d8b821cb1518c57131d007e23ddc93632abeeea098"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "642b23e4cceef02c4722d6dd4a3a1b21a1eef2f58b719ae26b217fd6ea62f79c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "813ce4dfdc0c59e2c4e38764c486264ec60bcffec506411b5c5e518876ce2d8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62571056a8ff6555c6768213c75dd3e96be9e73264e094a400c19de8b1209490"
    sha256 cellar: :any_skip_relocation, sonoma:         "762ab321e696f9bdc383d15bc73505d0ffde06184d4c209f76e84af839aa677e"
    sha256 cellar: :any_skip_relocation, ventura:        "3c7d206b19867e8fa0580b1ffe47b79bdadebf3e0d56378a5fae4c4ad7c4bc19"
    sha256 cellar: :any_skip_relocation, monterey:       "6539186720643f77abfc6546772507e3b20dafb40397f1534ad8cf80c959383d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5afd2738058cd9aedc2e0b48da7447ce11946a5d59313d68a96181df4f2d6331"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end