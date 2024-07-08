class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.30.1.tar.gz"
  sha256 "bc63b5fce7b1805af4e9381fe73ab1e4a8eba6591d9da4251500dfce383e48ba"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20b4ca7f6a8f0bea266b42dbdd8b2184c4bccd37f81e79db87a39d3e74264603"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4539a22da5dc34f753286b2d6385be4dcb102015a9aab2ae87ebbac3fcffeaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a0967d16e5da849d288c4e8ce01e4619b0cefb0683820d096dffb48ab297119"
    sha256 cellar: :any_skip_relocation, sonoma:         "57e30bad27e55bfa5b21a7bd2047cf3c4dc11dfc513eaa9384661b7d90fc933d"
    sha256 cellar: :any_skip_relocation, ventura:        "ad76d8eb74b25d8e72b05a097f8aa8804c5f60ebe68612a4dd8fd6c54b98296d"
    sha256 cellar: :any_skip_relocation, monterey:       "5dd5d8616f8eb080c6b516a8d938e7eb659fbbe1a17d2107ad3d1bf2a7e8ccf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bf6322f4224634e0dcbb0b97a2fb702953c26b7183ecab83ebc248ecb389f49"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"just", "--completions")
    (man1"just.1").write Utils.safe_popen_read(bin"just", "--man")
  end

  test do
    (testpath"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin"just"
    assert_predicate testpath"it-worked", :exist?

    assert_match version.to_s, shell_output("#{bin}just --version")
  end
end