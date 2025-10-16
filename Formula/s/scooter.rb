class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://ghfast.top/https://github.com/thomasschafer/scooter/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "4c70e0cf3a450b509c773b113bf21bc62ed228873bd45030b3359d391e3b188a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10b632d61cf600afe40726ab3fc6b9cbef070dd39363ddbd1e4235072bfd7563"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ebc8812c6c8695dd7a7506ba895562649717ec50e8d4f4db73034bfdfb8712e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d465d494109ae528a34758bfc44d0f4989215abfec3b54c6ec1795269884f008"
    sha256 cellar: :any_skip_relocation, sonoma:        "121ac5306d296c22ac21cf75d1aee4a8599c560b1c7c0fe112f7a8f4d6c16677"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "298472651f6f36cce3abe6a522854e30a950bc1c1b27f793932dbbe76ffcee76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1c919f6e7bc92fc84aa9a98c356b625711ecf1e707e1929cbe3212b7f2b5cb8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end