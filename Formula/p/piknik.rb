class Piknik < Formula
  desc "Copypaste anything over the network"
  homepage "https:github.comjedisct1piknik"
  url "https:github.comjedisct1piknikarchiverefstags0.10.2.tar.gz"
  sha256 "937e98cc80569e4e295baa0ad7fa998da593af137eb33e191b12b23d2ca3a666"
  license "BSD-2-Clause"
  head "https:github.comjedisct1piknik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5c60ad4cad0bbf6a504f28053f1668b8b209a6bf473a8c477f53a5bf7b4665b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5c60ad4cad0bbf6a504f28053f1668b8b209a6bf473a8c477f53a5bf7b4665b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5c60ad4cad0bbf6a504f28053f1668b8b209a6bf473a8c477f53a5bf7b4665b"
    sha256 cellar: :any_skip_relocation, sonoma:        "794e44f78e1ac05b76da93e9ebcd02080d4dae1fbcdb5e186fd8779215499136"
    sha256 cellar: :any_skip_relocation, ventura:       "794e44f78e1ac05b76da93e9ebcd02080d4dae1fbcdb5e186fd8779215499136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec30a0fe6f7a5e8995c8f14174d5e7fd5e51a843db398bdf1e5d05b5a1c0fa74"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    (prefix"etcprofile.d").install "zsh.aliases" => "piknik.sh"
  end

  def caveats
    <<~EOS
      In order to get convenient shell aliases, add the following to your shell
      profile e.g. ~.profile or ~.zshrc:
        . #{etc}profile.dpiknik.sh
    EOS
  end

  service do
    run [opt_bin"piknik", "-server"]
  end

  test do
    conffile = testpath"testconfig.toml"

    genkeys = shell_output("#{bin}piknik -genkeys")
    lines = genkeys.lines.grep(\s+=\s+).map { |x| x.gsub(\s+, " ").gsub(#.*, "") }.uniq
    conffile.write lines.join("\n")
    pid = fork do
      exec bin"piknik", "-server", "-config", conffile
    end
    begin
      sleep 1
      IO.popen([{}, bin"piknik", "-config", conffile, "-copy"], "w+") do |p|
        p.write "test"
      end
      IO.popen([{}, bin"piknik", "-config", conffile, "-move"], "r") do |p|
        clipboard = p.read
        assert_equal clipboard, "test"
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
      conffile.unlink
    end
  end
end