class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https:github.comwatchexecwatchexec"
  url "https:github.comwatchexecwatchexecarchiverefstagsv1.24.1.tar.gz"
  sha256 "9afc736fd4c0f895c89b7d6b1bbbb831fdb255400f785dcd3a414f62a5db6bd5"
  license "Apache-2.0"
  head "https:github.comwatchexecwatchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:cli[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61f6a098c64fbf1025863a4b1e13530b77dc613772fc0de4b96e5e6f4ddb8840"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23339e23189ab6f7c08dceaeca5b325e7b70bfabcf0fa9351bee0604ae8c6a9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe83a33e45460c08345589958ad5345f7b23c33376a3530f3c72696da6631790"
    sha256 cellar: :any_skip_relocation, sonoma:         "e60417b7ddf5a8126c79cacef486042afe62b002442934e6dca2c06ef9c6687c"
    sha256 cellar: :any_skip_relocation, ventura:        "96dbc5c165d8acd5b206979025728daee96f42fdfd1a21d6566e586cd91d66ff"
    sha256 cellar: :any_skip_relocation, monterey:       "dd3fd9ffe159cfe47887674266a95d995021f91901f50fae462ed8a3913b92f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41d76b33196a32a21e859faa880ca846d51d96937ac729735108422097374f0a"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    man1.install "docwatchexec.1"
  end

  test do
    o = IO.popen("#{bin}watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read
  end
end