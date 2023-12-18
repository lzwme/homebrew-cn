class Dub < Formula
  desc "Build tool for D projects"
  homepage "https:code.dlang.orggetting_started"
  url "https:github.comdlangdubarchiverefstagsv1.35.0.tar.gz"
  sha256 "7275cfbff1b8c8e2cb4a93ae98a8f4a6acdac88bbdc49e14aa66ea82a8539c94"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98dbdf3bf06f2fb09b86dd97ee41f7d84fd5a4d26f17671dab5ac35d2af653ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dd206f5e99ce55dcac05aa5db12fe569f294ae85c1f3aa6c7acc9b0c883422c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d540290a69dd42ed4642b7f6716961381a0582cb899dd45dc9179b09eb7b2be6"
    sha256 cellar: :any_skip_relocation, sonoma:         "362b1d2220eb1eea3ccc22131d668239c0a87726834689009bdda316414a0b83"
    sha256 cellar: :any_skip_relocation, ventura:        "87a084573c7a1a978e9b49960b3dca2a5f3dd8199c0c3b304be1e4f1a2801e58"
    sha256 cellar: :any_skip_relocation, monterey:       "79f6789133d8a066a5140ef4f8042e59134573987442780cc3835108a94870ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a5eabdc32de0b120e5767701f6f36d0b1cbf68523ac6508be5f2c2a5a6181e0"
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