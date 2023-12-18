class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https:github.comhashicorpconsul-template"
  url "https:github.comhashicorpconsul-template.git",
      tag:      "v0.35.0",
      revision: "2d2654ffe96210db43306922aaefbb730a8e07f9"
  license "MPL-2.0"
  head "https:github.comhashicorpconsul-template.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e36a391aa99c23adb75b3bb7c24780d8700da77165401e45af8da5576cc5bc75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f940fd4149aa4fdb9b932d8b501fce391a737c84a67caea36c8418c2312bae8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6765924a8a157ca80acad8f163496fbe08d516645a294bd7236c8673be2ad500"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fd32ba36477759cf9ce37dbb88f2ac5209cf364f0278aa1289a038a683acd50"
    sha256 cellar: :any_skip_relocation, ventura:        "3a221f7f734937acc3e619d6ce67c500af325c1091ba7a9e7ca0cbaef4b9a1b4"
    sha256 cellar: :any_skip_relocation, monterey:       "64f999bbb8eb04b0a6d1ba6b3a7fe197e5780d8f894e703bd8c3703c0d4af5bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75d511095c70ac6e10da35c5f77682a9622061374c9aec4f9255431a51a6c0e7"
  end

  depends_on "go" => :build

  def install
    project = "github.comhashicorpconsul-template"
    ldflags = %W[
      -s -w
      -X #{project}version.Name=consul-template
      -X #{project}version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    prefix.install_metafiles
  end

  test do
    (testpath"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath"test-result").read.chomp
  end
end