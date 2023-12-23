class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https:github.comsimonwhitakergibo"
  url "https:github.comsimonwhitakergiboarchiverefstagsv3.0.9.tar.gz"
  sha256 "b79aff39e1f741b56ca430b50dbcdca9999d5dafac64dcca6f42afa05d3cc785"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b593adbdee7a67832340feed72d82d16477145022477a2d54f49ad82d74e31f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc4c97bc66bbabec2db29ffcf8135a2a66af20181eb4dd01ffc722b08c8c2f82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fae8d9ec87eacbcd014d1aa5cabf31140f8ed6b020c53cff7c40b93024277522"
    sha256 cellar: :any_skip_relocation, sonoma:         "f63e07f0b1d565106c35e13895224f6b8b697b159f8adcc2f157f45f2e6694cb"
    sha256 cellar: :any_skip_relocation, ventura:        "3c7f67ac25bfc508d140fd1b869b4a0a96e60f588690858eeb320cb1e2a7cac7"
    sha256 cellar: :any_skip_relocation, monterey:       "81426867cf2e71f692e6f6379e5a2573483a5620d5c40291493b2279a411d2eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcaa848d743db01d18ed813f88b5754e7084ab3a8dcb5b1af349a2dba68d2e18"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comsimonwhitakergibocmd.version=#{version}
      -X github.comsimonwhitakergibocmd.commit=brew
      -X github.comsimonwhitakergibocmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin"gibo", "completion")
  end

  test do
    system "#{bin}gibo", "update"
    assert_includes shell_output("#{bin}gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}gibo version")
  end
end