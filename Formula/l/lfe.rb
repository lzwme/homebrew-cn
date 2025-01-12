class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https:lfe.io"
  url "https:github.comlfelfearchiverefstagsv2.2.0.tar.gz"
  sha256 "5c9de979c64de245ac3ae2f9694559a116b538ca7d18bb3ef07716e0e3a696f3"
  license "Apache-2.0"
  head "https:github.comlfelfe.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a159ef143d797954d5db248f504e2b2886f21687cb7ec19eb851eead8634897e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a57b6e2fe92cc45259a480b3211d1c88c00c9be76c468b02f473c9103a411c56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97316cd6885403793add3cd91ca7bbf4cc41f74149a0e245444a79e4d9c7838a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c4e7f7c678353746db25ee68ec489be421876b19fb42acedd71961260d4dfb6"
    sha256 cellar: :any_skip_relocation, ventura:       "2f6a92d45737000cf116f91e4576e5da979a934da8c27ab91cc8f28bf9e5aeac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "460cdd4bc3060210efa2bcdb29b2956a38f921cf9b59c5157ba34f3b4509668f"
  end

  depends_on "emacs" => :build
  depends_on "erlang@26"

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    system "make", "emacs"

    libexec.install "bin", "ebin"
    bin.install_symlink (libexec"bin").children
    pkgshare.install "dev", "examples", "test"
    doc.install Pathname.glob("doc*.txt")
    elisp.install Pathname.glob("emacs*.elc")

    # TODO: Remove me when we depend on unversioned `erlang`.
    bin.env_script_all_files libexec, PATH: "#{Formula["erlang@26"].opt_bin}:$PATH"
  end

  test do
    system bin"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+2 0 (lists:seq 1 6)))))"'
  end
end