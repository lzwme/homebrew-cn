class Dub < Formula
  desc "Build tool for D projects"
  homepage "https:code.dlang.orggetting_started"
  url "https:github.comdlangdubarchiverefstagsv1.35.1.tar.gz"
  sha256 "4355d7664bd588199ea9f8203f32cbb63981041b6c94a613ffafaaa45054fd2c"
  license "MIT"
  version_scheme 1
  head "https:github.comdlangdub.git", branch: "master"

  livecheck do
    url "https:code.dlang.orgapipackagesdublatest"
    strategy :json do |json|
      json
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "997b7c0f8f6fc5c271769a28ed0d0959a93b454e9c970bc5545945140a3cee0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6485de9f27a9ba34ee3487470f2aa49a5832d7195ed8185586bfccd7a9788bf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0ed4e5e6e33fb8c1bfa28902b90d5460733120433e9a6a74e11e11ef2756e95"
    sha256 cellar: :any_skip_relocation, sonoma:         "24f2608b0f04978359bc42e31f0a6ad8aedd6057caf073380602c3a16ad112eb"
    sha256 cellar: :any_skip_relocation, ventura:        "382b4ceece8bf6d8be595ccd58f158b3e518ca7f4d60fadd053d3505aa1b5cb6"
    sha256 cellar: :any_skip_relocation, monterey:       "50b10c9a571f65493f289f6f800273c5cddee4f5ba4ac89f0980a4f03261d164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "028530f29b733d6c8923b48406e1974b63211fdc7887a4a75419bf813dd292ba"
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