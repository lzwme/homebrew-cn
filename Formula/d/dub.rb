class Dub < Formula
  desc "Build tool for D projects"
  homepage "https:code.dlang.orggetting_started"
  url "https:github.comdlangdubarchiverefstagsv1.37.0.tar.gz"
  sha256 "8e8c5c841a43cb75af9828c3155a7e1ef90319177a66cebf9c94b33792cf8491"
  license "MIT"
  version_scheme 1
  head "https:github.comdlangdub.git", branch: "master"

  # Upstream may not create a GitHub release for tagged versions, so we check
  # the dlang.org package as an indicator that a version is released. The API
  # provides the latest version (https:code.dlang.orgapipackagesdublatest)
  # but this is sometimes an unstable version, so we identify the latest stable
  # version from the package's version page.
  livecheck do
    url "https:code.dlang.orgpackagesdubversions"
    regex(%r{href=.*packagesdubv?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d21733ea499d52f89454e5a4a5774faec8d2620e47fb93fb31d8d3ef4afffd0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74b745e9afaa045ff0a6c5e29ebb0465cbf89be800cc23a2731a54e74722332c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba0d48849d6e3ec6315c1dd4e1cc4cdb0d0c6a7d2c751a0fa697a9e05f23dc0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "269347d2f635c4f2227674eefd2d6cb55c34a79b83407525b4e7c4139ade2596"
    sha256 cellar: :any_skip_relocation, ventura:        "e31c20c38579aafe4dc22a8b8e4e7e842dc9f547966b35a3bd45e6c0efa3b0ef"
    sha256 cellar: :any_skip_relocation, monterey:       "e9512206fd815b156edfbdff48dfaf302331b08d458ceb43591a5a22da11ab9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ca3ecbce8d4fb1374fb8b20eaa7d1e4de063b2eb3d696890c7e617111b4df77"
  end

  depends_on "ldc" => [:build, :test]
  depends_on "pkg-config"

  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "ldc2", "-run", ".build.d"
    system "bindub", "scriptsmangen_man.d"
    bin.install "bindub"
    man1.install Dir["scriptsman*.1"]

    bash_completion.install "scriptsbash-completiondub.bash" => "dub"
    zsh_completion.install "scriptszsh-completion_dub"
    fish_completion.install "scriptsfish-completiondub.fish"
  end

  test do
    assert_match "DUB version #{version}", shell_output("#{bin}dub --version")

    (testpath"dub.json").write <<~EOS
      {
        "name": "brewtest",
        "description": "A simple D application"
      }
    EOS
    (testpath"sourceapp.d").write <<~EOS
      import std.stdio;
      void main() { writeln("Hello, world!"); }
    EOS
    system "#{bin}dub", "build", "--compiler=#{Formula["ldc"].opt_bin}ldc2"
    assert_equal "Hello, world!", shell_output("#{testpath}brewtest").chomp
  end
end