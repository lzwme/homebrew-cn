class Rospo < Formula
  desc "Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https:github.comferamarospo"
  url "https:github.comferamarospoarchiverefstagsv0.11.6.tar.gz"
  sha256 "7df7a5cb1dd95e7e46d302d71cffe13b0e4a13ffd42fdd21a4ebef2b75503340"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83777dc694f916b5dfd189717394c9aef0c2bd7a2bbbfaf9dad4fc08e0bebaad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03abe11d211a351bdf9b37835f76c9c088c73dc0006531b8c8d519bdf922bf0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "107b7e378f75b1e90fb2239e0db7ddfd6d2425947d49efd9f3b706b52c5aff0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e54f1916fcdd30c1afc977616f06a6bfb80428182f6c16ebd0b540df9da45cc1"
    sha256 cellar: :any_skip_relocation, ventura:        "5826517b11ff07a31d015b01114e15a821c6adfce47e82006d6987244571521b"
    sha256 cellar: :any_skip_relocation, monterey:       "cac5b71290e3f8f6a6e2a2a6d2dd47e7860b241942a612ae8dc5717e85ac2a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71d94b4edafbfbc9b0890cd054d50d1e0800e4b85c4c7735063a5516bdee0775"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.comferamarospocmd.Version=#{version}'")

    generate_completions_from_executable(bin"rospo", "completion")
  end

  test do
    system bin"rospo", "-v"
    system bin"rospo", "keygen", "-s"
    assert_predicate testpath"identity", :exist?
    assert_predicate testpath"identity.pub", :exist?
  end
end