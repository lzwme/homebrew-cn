class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv1.1.1.tar.gz"
  sha256 "42eafe9694da1a0062e64f224b6f3cf400ec144945a56ad0a758b603be620e53"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8a36528928a2481e77b7678475d60da35acb7d9e31d2c5ec69b47f7fafa10f10"
    sha256 cellar: :any,                 arm64_sonoma:  "6254352f391793b71f6648e6e64f1d869dbadc4bff1587658a8da676f07a5303"
    sha256 cellar: :any,                 arm64_ventura: "5f6479af651c2818457eba9b98d8279589dd9408806bb3c7dfb1c2b7ce3af19a"
    sha256 cellar: :any,                 sonoma:        "2b5f535f329f001427c60ebfe1ff04de887190bab95f47ebf16ae72c13c3dff7"
    sha256 cellar: :any,                 ventura:       "8b2099dad860042406dc7b1f8f5b74d08b785699e574b220c2e8bcaff7d06eb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffdbe48f55af644b5336865dcad13626d4ab93086707b951dc08abb25fdc1ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a646cbc5d74fa77a2e415528aae5e6e2b56957f341850d9c05082abac2f152b"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"hk", "completion")

    pkgshare.install "pkl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}hk --version")

    (testpath"hk.pkl").write <<~PKL
      amends "#{pkgshare}pklConfig.pkl"
      import "#{pkgshare}pklBuiltins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = Builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end