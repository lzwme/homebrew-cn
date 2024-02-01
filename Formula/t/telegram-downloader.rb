class TelegramDownloader < Formula
  desc "Telegram Messenger downloadertools written in Golang"
  homepage "https:docs.iyear.metdl"
  url "https:github.comiyeartdlarchiverefstagsv0.15.1.tar.gz"
  sha256 "4bd9d216d4e6b5cc4217ceebb7419660543eff778aa3397978055bbc1b61d393"
  license "AGPL-3.0-only"
  head "https:github.comiyeartdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6aa5873ba98033b39a328676659e32b361ceb388cecab69742794f2e82ccbb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b624281fce6baaee1facb1e99abe0418d6dd1b5f4630bf0bf538bb02452c3e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d8c62c1eb7eacb5c371ff09c18b1dba3346fcf47b299e306f5aa7a7ec5988d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9ae1e02d65837cb2389db6b857525ed9c9561d7e0c416ce67bd04b2f486ca26"
    sha256 cellar: :any_skip_relocation, ventura:        "e057e060e22430b3cdf7136ed6304b52c6740547d3bc81af16aaa3463de5dce4"
    sha256 cellar: :any_skip_relocation, monterey:       "6e5a4a5f41fd7318fdab7452f9e935de3089b3d48f878c8f43785dc68e23be6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86729a505e005bc22d607edb611ebb1d4b4e60cda3c98d58c6e205ad10df1de7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comiyeartdlpkgconsts.Version=#{version}
      -X github.comiyeartdlpkgconsts.Commit=#{tap.user}
      -X github.comiyeartdlpkgconsts.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin"tdl")

    generate_completions_from_executable(bin"tdl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}tdl chat ls -n _test", 1)
  end
end