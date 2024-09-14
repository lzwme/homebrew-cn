class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv2.1.2.tar.gz"
  sha256 "54aff2355c2935c1e8c93ce9f342267e99921a3a7276be78e30af0f20e2ab776"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e87766a690218554c0c2bec475d43e146c1fad5b48a7ea7210caf27047a4f7dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e87766a690218554c0c2bec475d43e146c1fad5b48a7ea7210caf27047a4f7dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e87766a690218554c0c2bec475d43e146c1fad5b48a7ea7210caf27047a4f7dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e87766a690218554c0c2bec475d43e146c1fad5b48a7ea7210caf27047a4f7dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "84e2d9263c9ae80b5edb2fffe965533c4a7cab7c7d064488065d9117efa2fff2"
    sha256 cellar: :any_skip_relocation, ventura:        "84e2d9263c9ae80b5edb2fffe965533c4a7cab7c7d064488065d9117efa2fff2"
    sha256 cellar: :any_skip_relocation, monterey:       "84e2d9263c9ae80b5edb2fffe965533c4a7cab7c7d064488065d9117efa2fff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58cd8b5dd766dbbe8c3b2572de06fad06b25574cb2e0cf4b91e2ca7669bf95c9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin"lk"), ".cmdlk"

    bin.install_symlink "lk" => "livekit-cli"
  end

  test do
    output = shell_output("#{bin}lk token create --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}lk --version")
  end
end