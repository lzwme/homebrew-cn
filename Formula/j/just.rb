class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.41.0.tar.gz"
  sha256 "4ab64ebeaf7d6cf90d2824fddb91f7a3a4cfbb5d016e99cc5039ded475c8a244"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c28f567da146055fd5be7376d675c268be795dcd2aac6559ad8b68174a1587fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b4a7a8e0215938a833cd45d38e3c4efb3ac238587c51c06c10dc0e0a285cd97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfff15878146a57c587a6647260378230127f74df7f0080be862c945bd890d3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7bb53b20afea67788552608f02e0928a5348c77bf5a53c34ab5ebe9bdf97a7d"
    sha256 cellar: :any_skip_relocation, ventura:       "db17913b40c4f5a354c65f119d0e5ea984d997deb5162d740d917dd60f94807a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df3b4f2cb92207b8abc551685eb38207962648997efa768349ba1c3b30c5e905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7119732bf0e44d6f4394a989abff7fdcfcce50b6f24b22e57dc180c1aabacf5"
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