class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelmarchiverefstagsv3.15.3.tar.gz"
  sha256 "f4eb30fa8285091ceffba16cf5ad7ec4b444897bd1df615af4bef3842f6d6d0e"
  license "Apache-2.0"
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "827f6a04199af59844dfecb346ab096a2684b1c7dc0a4b82f6c155842524dc7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75e248744bdf1bd99f85bca02a12f6f57550d60a59bd814ece38a330ee52d741"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84e42ca0cc01fa6e9dca03cfcfede9b02318d13fe81cb1b2be42e0bc4b25d0cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "e14a0b990ea7ceac59c6e33c8565ebcd89430b9d54fb697443419ea6db4f2e0a"
    sha256 cellar: :any_skip_relocation, ventura:        "df7fc5b133e2038d4f7805775a59442032f3ff3b7dea27aa36ea6b415df194a0"
    sha256 cellar: :any_skip_relocation, monterey:       "d6a4d28fa4ab4c2d832bf0a5911de6091172aa0546bae32338bfcf7ece068457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbdc826f25219deb0187c808ff576a84ea69527d887f5cd4848f8bfe7ee4a411"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X helm.shhelmv3internalversion.version=v#{version}
      -X helm.shhelmv3internalversion.metadata=
      -X helm.shhelmv3internalversion.gitCommit=#{tap.user}
      -X helm.shhelmv3internalversion.gitTreeState=clean
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdhelm"

    mkdir "man1" do
      system bin"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin"helm", "completion")
  end

  test do
    system bin"helm", "create", "foo"
    assert File.directory? testpath"foocharts"

    version_output = shell_output(bin"helm version")
    assert_match "GitTreeState:\"clean\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end