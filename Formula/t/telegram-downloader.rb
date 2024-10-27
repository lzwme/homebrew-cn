class TelegramDownloader < Formula
  desc "Telegram Messenger downloadertools written in Golang"
  homepage "https:docs.iyear.metdl"
  url "https:github.comiyeartdlarchiverefstagsv0.17.6.tar.gz"
  sha256 "956e5630de32940baa0e2a1effa702a53457e3fa31bddd7cc32829219f3abc6b"
  license "AGPL-3.0-only"
  head "https:github.comiyeartdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfc0ddb0ede3462c041af7b2bf045ba9c964ee09937ede46e76ba25d92d4d570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d176cf27702c8db460375a8df02f6aa1c64e7b6e677ceb307606e3b37457b3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e86f7e1ba64441a54899b32973f3bcc00f94cce11cea0686e01ba8bc189f1f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "db5d158014f45c14b5bd7e486e34e4bbc3383902bf5db55249229755d885c784"
    sha256 cellar: :any_skip_relocation, ventura:       "f1b9a90e493afad7cb2e58b2218fc368cab4a9a5569e549be57484d818238f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c02138fc563cfca03dd4f5114874eda30cacb68425b5b07b0365d247cac850a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comiyeartdlpkgconsts.Version=#{version}
      -X github.comiyeartdlpkgconsts.Commit=#{tap.user}
      -X github.comiyeartdlpkgconsts.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"tdl")

    generate_completions_from_executable(bin"tdl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}tdl chat ls -n _test", 1)
  end
end