class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.44.1.tar.gz"
  sha256 "ad93602b25c87de0f3cb90c5970a5b8f5ccca6fb87ae393be7e85477d6bbd268"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ed7e216cc205f3b2dff08ebc29ae930f041921e7c476a8d897204d18c387abe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f086f0b14c4e34eea8a85befcc3845a2b0e2a4f7967b67c69a7161d9b445e13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aefbd3a29de06eeb615caaf8ac6072361b2901bd964b057c58d52884abfe1403"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf99b091d9be104711cd3b9e045f133b098d0d77bde72a5977ac474b572e292a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e23525cde05dd389e2b5a57754c1ddb72b900af57f02b26945aedbb4b98f11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a43f69dd95e42d3de9c220dce9437bbc5351f90081ed2810bab37994161362ef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end