class Grokmirror < Formula
  desc "Framework to smartly mirror git repositories"
  homepage "https:github.commricongrokmirror"
  url "https:files.pythonhosted.orgpackagesb0efffad6177d84dafb7403ccaca2fef735745d5d43200167896a2068422ae89grokmirror-2.0.11.tar.gz"
  sha256 "6bc1310dc9a0e97836201e6bb14ecbbee332b0f812b9ff345a8386cb267c908c"
  license "GPL-3.0-or-later"
  revision 4
  head "https:github.commricongrokmirror.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0734b350dbe50cc991fd9218e541b96019e4af7fd6ce3c4bd71ea75967173f60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0beff38baa132fe21dac39b0b1d7b1e5dabd51733b81d1ba32efde71197eeb2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00b1f516078c53c36278dd5bb921bffa18407ca0c5023a3eaa8dd9d2c94ddc72"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c627c8fc433d1d1a19a104eabb6e314e569fd35047d45575239a867a9cdb9b3"
    sha256 cellar: :any_skip_relocation, ventura:        "68848143483b3ddb6cbfc5c688051dafe18c9ac36edea2cb5b9777a3ffc9f4cc"
    sha256 cellar: :any_skip_relocation, monterey:       "6f287d5751e12b42008fa2a4ae311a90e859540a8d97a0cfa7db75320f2f1956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc1cb99b2b9e001670c44d3790e7dd1c2fc9990d288032220116b60a809c582"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    mkdir "reposrepo" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
      (testpath"reposrepotest").write "foo"
      system "git", "add", "test"
      system "git", "commit", "-m", "Initial commit"
      system "git", "config", "--bool", "core.bare", "true"
      mv testpath"reposrepo.git", testpath"reposrepo.git"
    end
    rm_rf testpath"reposrepo"

    system bin"grok-manifest", "-m", testpath"manifest.js.gz", "-t", testpath"repos"
    system "gzip", "-d", testpath"manifest.js.gz"
    refs = Utils.safe_popen_read("git", "--git-dir", testpath"reposrepo.git", "show-ref")
    manifest = JSON.parse (testpath"manifest.js").read
    assert_equal Digest::SHA1.hexdigest(refs), manifest["repo.git"]["fingerprint"]
  end
end