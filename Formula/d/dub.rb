class Dub < Formula
  desc "Build tool for D projects"
  homepage "https:code.dlang.orggetting_started"
  url "https:github.comdlangdubarchiverefstagsv1.40.0.tar.gz"
  sha256 "52b963137e8a671e48ce3b64eb1e424f6a3c137b8001cf74fb98932def61c171"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdc35c943741ff4daa5204c4787fad70b3ed94dc31abab026c195df73fcf13ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bca28b6b780e086f88bad5ffb32abb71d8b9d8f256d17547cfd6aa4d4a5fc346"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abf4f33add519521441ebc0af2ceb04cb2261496e3962dec491a0a0c16770f42"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cdc341f90c51af8a19fc8ce5dbfdbfa7054ccde65363da365066609f4b8cd62"
    sha256 cellar: :any_skip_relocation, ventura:       "52f26e201118800cf552bf0a7f57df4afaf90300b132035fbd52325224d7b861"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a4f71c32ebc9395d31b401219449820ddcaad85415a1deff1ff770322faa1b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d68877d9ac67d2e682a19cdef3d6867f700b1aa52afa5125f8851de3cd01a695"
  end

  depends_on "ldc" => [:build, :test]
  depends_on "pkgconf"

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

    (testpath"dub.json").write <<~JSON
      {
        "name": "brewtest",
        "description": "A simple D application"
      }
    JSON
    (testpath"sourceapp.d").write <<~D
      import std.stdio;
      void main() { writeln("Hello, world!"); }
    D
    system bin"dub", "build", "--compiler=#{Formula["ldc"].opt_bin}ldc2"
    assert_equal "Hello, world!", shell_output("#{testpath}brewtest").chomp
  end
end