class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.42.1.tar.gz"
  sha256 "6a6ec94ae02791c2101fd65201032d7c1929fc6294e4deebc92d0e846882fe15"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65620038796307ffbb1593decac1da8e774110115a5c7a5181ea8658b8af67ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0cbef6960c618dcb05682a1bfedbba1a20f70f01c363266e6ae3e518a7372a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "756affc06c98c2bcd94ef62803447663cf303df143667afd3ff7c46aa6d1cfda"
    sha256 cellar: :any_skip_relocation, sonoma:        "adce6c0528e52f097a55fd5c5889174f4414baa6d7f048dea3fe8eec23acd92d"
    sha256 cellar: :any_skip_relocation, ventura:       "122daf8abf3a2e4feab4ea0aee62df290b69494afc8220749524b6edccb9f2cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bf58c51af93ad46077a4fbca804bbda7dede0b295d1c5c38d845f877689f065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0225e3816cc19dceb79d6ce85236a12fce7e90aca64b6b1b253efefc0125d0b4"
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