class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.7.3.tar.gz"
  sha256 "1f59a1e41034e854403cbe74c70a213b7c7392ac7154445f8649f24e02d947be"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4d747e5246c59946feb8937f3bd30ed077804a4bf850c76ebb7b500e7c34f0f0"
    sha256 cellar: :any,                 arm64_sonoma:  "4cc0a3359828d3d9e768d3fd8b577f4d45414341e5b99e42b149fd3351446879"
    sha256 cellar: :any,                 arm64_ventura: "a83c51b2bb5272ba012a6ec1927d7071545e9780c507c293d84c1f9f491aa4dd"
    sha256 cellar: :any,                 sonoma:        "14af8a7908922a4530c1d92a086e1ced74dafb3de8c7f658f1b5f9de68808421"
    sha256 cellar: :any,                 ventura:       "dba8264a1fbc9c65d119933778587ebeee8c2f1cd76394df4d9def1ab79987bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c360e4066ebc0aa037e3ec24cede9f6a08f92548428634bbe6b575fd47d080c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "010e3849123afe5b28705c5ec4d8f96224c2a9ca47e7818feb46b3bb244f00a2"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}hk --version")

    (testpath"hk.pkl").write <<~PKL
      amends "package:github.comjdxhkreleasesdownloadv#{version}hk@#{version}#Config.pkl"
      import "package:github.comjdxhkreleasesdownloadv#{version}hk@#{version}#builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = builtins.cargo_clippy }
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