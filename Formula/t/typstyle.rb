class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.7.tar.gz"
  sha256 "53656d85125b9f96f12bd1c98bb9e3f0a58c9047efcfa3d3f216e54665e687cb"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8b6a18487309dc2d1deae18c9a8995fa10d7b44edb446ca4d21ab477ee3ea05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8dfb42bd1869fea344002816a11642b82ce98ff5e15162067c429f4f050f3c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0878131785299988af660201b197e1fc32dc890d8535d23c96fd10595a29e191"
    sha256 cellar: :any_skip_relocation, sonoma:        "f52b6b4a338d9b2dee611360159e07c75998716ae3e22f0a2d3f843c8c79d62d"
    sha256 cellar: :any_skip_relocation, ventura:       "82f38f1a18cbddb4ed417737f8fb9f11e253d1a184d9ea0344195e82acc2e31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b3235af194375a292d3af252c67731e35944f08bad16b6d3032f0a79d8642a2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end