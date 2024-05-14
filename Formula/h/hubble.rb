class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https:github.comciliumhubble"
  url "https:github.comciliumhubblearchiverefstagsv0.13.4.tar.gz"
  sha256 "5a1103bae2242df080436ee3ac3f0904b0208b5a00bf77c0a016f466a76203fe"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82cfe9426b926dd72738078695cef5d7c6be5a5ce941f12524319a4bd41c0c18"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4a6c54f5ab3b7e4790749dcd9293278fe2dcc0bbff0f6ae4fa641dd1412f62c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7070141f52c1d0dcaa1cebe6b0822024f0efd4153f146324fbec8bd05ccc282"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9c4f75cc9c7542db3b8ac000c05785069d27d28158613bebdd665ffe4fca96e"
    sha256 cellar: :any_skip_relocation, ventura:        "adb6e386f30e087abdfb2248645738834b23228661d63dc8a93a4282744b347c"
    sha256 cellar: :any_skip_relocation, monterey:       "2d1377d402014f624af8e1ec665035da89a8f378df5a3a8e1818e1272d9fb6e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7bd4031ef956e302e5dd8c86bda236a829ae7aefbf5068da7ad5b8f6fce92f7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comciliumhubblepkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"hubble", "completion")
  end

  test do
    assert_match(tls-allow-insecure:, shell_output("#{bin}hubble config get"))
  end
end