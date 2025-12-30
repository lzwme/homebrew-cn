class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://ghfast.top/https://github.com/sxyazi/yazi/archive/refs/tags/v25.12.29.tar.gz"
  sha256 "95d426eb933837bc499d3cddadaf845b919586d0105ffb831dcd5e085f73fd6c"
  license "MIT"
  head "https://github.com/sxyazi/yazi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1ea8fa23afbc725aff06c304a30fd303807a874151dad6101874b9d83cae94e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9f28f325a26f9258e730a93b6b2fd6f891d0491b5e82ec1c862e9d74d0ac08a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "574f15574d345a82da711338b46d6737ba5dd49cb18a0359edd4410d5653d76a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bb461edf43231afee496619ef31b7a783ead4ed7a47dd3409a143e511071105"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e4f488373f021a9f3a0420e715e19029cbc02b9a6feba581803a91417c22fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bd7b91a909f4b703cdff63e7e5f5b32d299a591d776d434d1683039ed281009"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_SHA"] = tap.user
    ENV["YAZI_GEN_COMPLETIONS"] = "1"
    system "cargo", "install", *std_cargo_args(path: "yazi-fm")
    system "cargo", "install", *std_cargo_args(path: "yazi-cli")

    bash_completion.install "yazi-boot/completions/yazi.bash" => "yazi"
    zsh_completion.install "yazi-boot/completions/_yazi"
    fish_completion.install "yazi-boot/completions/yazi.fish"

    bash_completion.install "yazi-cli/completions/ya.bash" => "ya"
    zsh_completion.install "yazi-cli/completions/_ya"
    fish_completion.install "yazi-cli/completions/ya.fish"
  end

  test do
    # yazi is a GUI application
    assert_match "Yazi #{version}", shell_output("#{bin}/yazi --version").strip
  end
end