class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https:github.comcrunchy-labscrunchy-cli"
  url "https:github.comcrunchy-labscrunchy-cliarchiverefstagsv3.6.5.tar.gz"
  sha256 "7669e77516449aabd9357db4e2180dd9a6d936f28552a11ad350fca97f1947a3"
  license "MIT"
  head "https:github.comcrunchy-labscrunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6588e1ef4c4862ce9d8ffae11aa0ca5ce286477dfefbc0d52d8a0a3f3daca6a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8954f9288866d4181ab263db9fd5e908b5dd42ddfd0c60c8478cad8640d1f35a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e657edd5c811fa3fbe17c5dc37f3e6bd02a89942429d6f92e0cdaa6e0079b45"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f9c2ee44d4ddd589c2a0a90d0b15c2209812649b25f3359c20043143ab4df40"
    sha256 cellar: :any_skip_relocation, ventura:        "f649e546ad78af17a372a20009ece2163643dddca4fe7251f1b1949c2a5a43e7"
    sha256 cellar: :any_skip_relocation, monterey:       "1b119bd12b895c89a54b12a9a1fa65e42a3076d9f540b4c36dc4c2ce1e2748d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b77fcdb92240917bd477bad14bded6c5472d94c6272e6426b69cd74ba33ca38"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--no-default-features", "--features", "openssl-tls", *std_cargo_args
    man1.install Dir["targetreleasemanpages*"]
    bash_completion.install "targetreleasecompletionscrunchy-cli.bash"
    fish_completion.install "targetreleasecompletionscrunchy-cli.fish"
    zsh_completion.install "targetreleasecompletions_crunchy-cli"
  end

  test do
    agent = "Mozilla5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko20100101 Firefox119.0"
    opts = "--anonymous --user-agent '#{agent}'"
    output = shell_output("#{bin}crunchy-cli #{opts} login 2>&1", 1).strip
    assert_match((An error occurred: Anonymous login cannot be saved|Triggered Cloudflare bot protection), output)
  end
end