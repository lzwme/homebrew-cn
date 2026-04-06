class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https://github.com/KSXGitHub/parallel-disk-usage"
  url "https://ghfast.top/https://github.com/KSXGitHub/parallel-disk-usage/archive/refs/tags/0.22.0.tar.gz"
  sha256 "56a559fe591539b6a843ed6b4f2cf02a0eb759f5fbe905d2784f83beecda913d"
  license "Apache-2.0"
  head "https://github.com/KSXGitHub/parallel-disk-usage.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f79ff9a53a14dfd44e2f13efac6e0a955bc80adf914204c86e35f99ee20f2c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81d4ffdd914078d92aa974cabead7d5628d4187c718aa7f72afa051bf362c8ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d07c640fc9c9a0c6bfa422f084e4935835b88eac52432c9b55f4110e0bce4b6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e96496cf434c2ef852d78697f16eb6dd781050077d7b9bde53d80f99eee08ec2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6edca8390fdf7be02f76538cc7d2c386a3e04113a999a7e9f0ecb0ca0b4174d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "696f0d55f344917787a84f172cfe1a6f3e607f65d579fc946d50c2c04f628429"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "exports/completion.bash" => "pdu"
    fish_completion.install "exports/completion.fish" => "pdu.fish"
    zsh_completion.install "exports/completion.zsh" => "_pdu"
    man1.install "exports/pdu.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdu --version")

    system bin/"pdu"

    (testpath/"test").write("test")
    system bin/"pdu", testpath/"test"
  end
end