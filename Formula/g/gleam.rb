class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.8.1.tar.gz"
  sha256 "5ad243c092fb229d0ae77214beaa462cd9a53018e553decb9b12a2ea1fab6494"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff54bd662e5e3614a6de98eebce6a9c87a17fde112ad1e4e49406817c1d4f566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "500d920e194c8105fae37115ac8b8db04c5c17f23eaba3bec376abce2b2b7543"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c259f4f274702f0ccd412551242d2353dc03c551f0de5ba2a49de400562af5ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "bddb5a83c9e90c56e63288f90124fc1bbad3e6ddec577e76333d53db28aceb4b"
    sha256 cellar: :any_skip_relocation, ventura:       "0e5c30c8bd01453d2120ca7fe81ceb6872a80a9a1bd9d7c3209dcb4fa64cb334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be37d497809c98ce7024dec46e83cb9582801af02c59ba962d5065db54819cd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    system bin"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin"gleam", "test"
  end
end