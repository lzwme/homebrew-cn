class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https:github.comkahinggoofys"
  url "https:github.comkahinggoofys.git",
      tag:      "v0.24.0",
      revision: "45b8d78375af1b24604439d2e60c567654bcdf88"
  license "Apache-2.0"
  head "https:github.comkahinggoofys.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "53acc931a935c3e7c6230a59d492bf0cea7238167415083232d6ef37741b1cdc"
  end

  # Discussion ref: https:github.comHomebrewhomebrew-corepull122082#issuecomment-1436535501
  deprecate! date: "2023-02-20", because: :does_not_build

  depends_on "go" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath"srcgithub.comkahinggoofys").install buildpath.children

    cd "srcgithub.comkahinggoofys" do
      system "go", "build", "-o", "goofys", "-ldflags", "-X main.Version=#{Utils.git_head}"
      bin.install "goofys"
      prefix.install_metafiles
    end
  end

  test do
    system bin"goofys", "--version"
  end
end