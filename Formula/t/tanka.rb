class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https:tanka.dev"
  url "https:github.comgrafanatankaarchiverefstagsv0.32.0.tar.gz"
  sha256 "5d328d3a499787b1eb5d20ddbe20119048636e972db6cd75a3bb83c415f1cce3"
  license "Apache-2.0"
  head "https:github.comgrafanatanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68f328c212a17e0770693e85a98492e7c7bd5db2717f253addda414898213394"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68f328c212a17e0770693e85a98492e7c7bd5db2717f253addda414898213394"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68f328c212a17e0770693e85a98492e7c7bd5db2717f253addda414898213394"
    sha256 cellar: :any_skip_relocation, sonoma:        "699264d6515427f4c916a519a014946b2d6d8483f70a9f7c8d05a5e9b805a67b"
    sha256 cellar: :any_skip_relocation, ventura:       "699264d6515427f4c916a519a014946b2d6d8483f70a9f7c8d05a5e9b805a67b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93a66c137ec158f06004a53ac11fc6472e637f7a31aeecf77dbee1982b1f4f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab0a88919e82c9def686caac9958e5e902234cba479cc562e8fabf22397187da"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.comgrafanatankapkgtanka.CurrentVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"tk"), ".cmdtk"
  end

  test do
    system "git", "clone", "https:github.comsh0rezgrafana.libsonnet"
    system bin"tk", "show", "--dangerous-allow-redirect", "grafana.libsonnetenvironmentsdefault"
  end
end