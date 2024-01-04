class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https:linkerd.io"
  url "https:github.comlinkerdlinkerd2.git",
      tag:      "stable-2.14.8",
      revision: "3af6563ea346014f7d87bb71fa77dd76f17afe7a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^stable[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b9b4390d3d7221c7a65f770e0df9556ccd66ff429fafa7dc1b0bde5e4266a24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4e4101b9f30ab97be170a841150d7e802898dd86aacb8a00ba14828134262e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f473af28c4c05ce03e6fefb7adb772f722f61bb3a3f9720076522691f7161bc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad782c0189589550768e48b2b1ed3558cd60e966782ca2d2a736877f1276a2e1"
    sha256 cellar: :any_skip_relocation, ventura:        "65b38ed91aab973a371c56df7e5263b2f4cea7660a8b647edf9f912b8fbaf9d1"
    sha256 cellar: :any_skip_relocation, monterey:       "06c67ba4be20b55e894f7ea55605a1547db49fd607bd0df7793118612df4b571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93d800b732c6b68ad65894af15ac93a0d26fb9f4bf3c4b75cbfcce5bcc23bc14"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "binbuild-cli-bin"
    bin.install Dir["targetcli*linkerd"]
    prefix.install_metafiles

    generate_completions_from_executable(bin"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    assert_match stable.specs[:tag], version_output if build.stable?

    system bin"linkerd", "install", "--ignore-cluster"
  end
end