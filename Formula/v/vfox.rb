class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://ghfast.top/https://github.com/version-fox/vfox/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "2cb59e497724d28ae1d87f2578a73421083095ce5f9ce844cd98f77802b3d936"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16028f7fe2451ff30e2b9ba8d59dd0ebda79b61f3b3cda082b35e3bc1099bd2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a38df6c58567cd7a94c52b9c90335011efc6ede3cf191271cb0e08fcd9f0a6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0b4c2ceaf456217081ea7bd315a5f7ffe32a12e967dacf75a3bad0aad7d8ced"
    sha256 cellar: :any_skip_relocation, sonoma:        "34d78940fc00f412dad03d3d824fd133ce6c04950ce8d33f4ac3fe6863e596fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ace3b9023e882a103df253691286eda34504cb7584e5005613e157418fc3ed0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output("#{bin}/vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end