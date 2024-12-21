class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https:github.comdandavisondelta"
  url "https:github.comdandavisondeltaarchiverefstags0.18.2.tar.gz"
  sha256 "64717c3b3335b44a252b8e99713e080cbf7944308b96252bc175317b10004f02"
  license "MIT"
  head "https:github.comdandavisondelta.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72f71a3c65ca42df002ecb19c2c2753ad3f7775627a695b883b46397f6388d32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0adce7cf374bb8b2e8f60814122c53127d655e4b8417b4e99b1ff6ba01fa9dcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e362ccd581b14fb81081d88acf80430420181dc75b76f0a14a490bb08e286f6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "96faa7e5ee63146bebf5d19c81866b7a2c75d86251b6f510b651831a74df8d17"
    sha256 cellar: :any_skip_relocation, ventura:       "f8347ff888ee3413ae229016599be1282ae64513fb59f6cd109117ad323fccdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "648cb09c1f3e235689a01517c4953948f22e49be3a36c2038917744ce094bcdf"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"delta", "--generate-completion", base_name: "delta")
  end

  test do
    assert_match "delta #{version}", shell_output("#{bin}delta --version")

    # Create a test repo
    system "git", "init"
    (testpath"test.txt").write("Hello, Homebrew!")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"
    (testpath"test.txt").append_lines("Hello, Delta!")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Update test.txt"

    # Test delta with git log using pipe_output
    git_log_output = shell_output("git log -p --color=always")
    output = pipe_output(bin"delta", git_log_output)
    assert_match "Hello, Delta!", output
  end
end