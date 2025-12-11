class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.45.0.tar.gz"
  sha256 "e43dfa0f541fd8a115fb61de7c30d949d2f169d155fb1776abeaba9be7eb0e07"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6c25aa943b75f70e5aeed58c5440a309a10399be296868b909b7d2782e687ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d69f9de2776f94569881a847a6f9af1fb3857dca29c19d39b73b8196eaa67901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e4dab850eb8b87b2fd05995e01de5a638c054a2b327786271fee24c2c13208a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3de7ce4617fb10b3cfa4c122ff327a99866b7259e2d43797d48b0abde8ee5dcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72b2968615e321ea0d8464db012c68257b99bdd4b3d28b2ae8f1f2b6bc0930a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "539fada56f573389666ecc789b93d513c016a7160d228d0fe5706d938e7bd9f6"
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