class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.31.0.tar.gz"
  sha256 "6cef9159bb929c94b105015c28b0c94618556cfd2f1a1f17c012a1365ee8a8ac"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfef570574adb8cb5d15344307191992a7999f77f9af9e38528770e6395982d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa592c3bacd0ab65df47998b72ac31852e44c692b94fe945b78f299467dc78c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34fbca2c442b9811276425223d3c008fdec289bb733f4ab7bbe0d69ed1761950"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca2552069869f4344a4ce5afb6980c97ba8a260f0e8cf80611475e7703f93845"
    sha256 cellar: :any_skip_relocation, ventura:        "4f34591e9ded5b364fb5fba802473f5b1730f23745fe64d61644ba8f6daf39d6"
    sha256 cellar: :any_skip_relocation, monterey:       "0eff390cbfddf6a7878ef42be0c6107cf776f82ea803fcd770f087244d49fb95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9163a153aa5c96f82507e15df401da4e28eed52148e0f28c00b9e5f551ae7ce0"
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