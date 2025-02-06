class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https:gitlab.comtimviseeffsend"
  url "https:github.comtimviseeffsendarchiverefstagsv0.2.77.tar.gz"
  sha256 "b13329704c5eab7c74ebc29c3f2209290ea00e758139daaefc0ab0d5728c2fa4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d60f43b2fdb056059608e05dd6e4e9f1fad57486180c3732a40ffaaa440116d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98551254d908b6fa9496bfd9281fb359c7fdc34b9d172db68d1fa633d8c67f07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "398d00de4d062551f33c186bdb932c9ae62847f5e0a594663d4d09886ecbcc69"
    sha256 cellar: :any_skip_relocation, sonoma:        "58610267085cd19c5445172c1f59662c58b840b6ac3bcc4da04a8598ba222f6a"
    sha256 cellar: :any_skip_relocation, ventura:       "f4784a7c6f31e7e0ab55e1c44095c84ab20544a05211c20b212e14daaf143e13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2800da04659f26aacbd7ca4619fa0a06762cc5ef0c652630c139881f64c5aeba"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "contribcompletionsffsend.bash" => "ffsend"
    fish_completion.install "contribcompletionsffsend.fish"
    zsh_completion.install "contribcompletions_ffsend"
  end

  test do
    system bin"ffsend", "help"

    (testpath"file.txt").write("test")
    url = shell_output("#{bin}ffsend upload -Iq #{testpath}file.txt").strip
    output = shell_output("#{bin}ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end