class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https:lfe.io"
  url "https:github.comlfelfearchiverefstagsv2.1.3.tar.gz"
  sha256 "83a80e9baf89045d3975a01b89ef679544d693a689f1798f05360ab0ca20df15"
  license "Apache-2.0"
  head "https:github.comlfelfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54f4abc89c755f8bb423c6ad01633b7bdae3ff6a1bccfec81343c950bde60929"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec25b0ec7256116bb3c3799ec3ee7f74e699d0b6c9caa6c9537b9c40eb8282f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83c8784ed4663e909e29ebf06768e0ee39b4ffba766d1a9ba7bf275f27c88c68"
    sha256 cellar: :any_skip_relocation, sonoma:         "94af29556c3219b64f80407e7496942faa672f4ed5ed81030f7c4c9f2d120a68"
    sha256 cellar: :any_skip_relocation, ventura:        "b6a84acbdf580df8ade97ec02240f53d2fcef54edb8053909e456b40a6cf9591"
    sha256 cellar: :any_skip_relocation, monterey:       "d56403823d364c06f81e42b72aa34179d4360cd98ee086de2aeb7783f989c267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "660e26f4386a135c491a31c89a548680b3f39d1cbcf9448daac88a0f004cb9dc"
  end

  depends_on "emacs" => :build
  depends_on "erlang"

  # build patch for macos, upstream pr ref, https:github.comlfelfepull487
  patch do
    url "https:github.comlfelfecommit7115d469e3239d7e7965db101e3e98675840a8f9.patch?full_index=1"
    sha256 "96e08c3517bc905f53a27e2678018a9f4d5d3297cb9c6e18a35b71777fdcbc8f"
  end

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    system "make", "emacs"

    libexec.install "bin", "ebin"
    bin.install_symlink (libexec"bin").children
    pkgshare.install "dev", "examples", "test"
    doc.install Pathname.glob("doc*.txt")
    elisp.install Pathname.glob("emacs*.elc")
  end

  test do
    system bin"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+2 0 (lists:seq 1 6)))))"'
  end
end