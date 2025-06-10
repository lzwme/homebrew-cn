class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https:aquaproj.github.io"
  url "https:github.comaquaprojaquaarchiverefstagsv2.53.0.tar.gz"
  sha256 "6f5e7bec94254af78d7604b493953337999f565a0e64de5efa669d31feab65cd"
  license "MIT"
  head "https:github.comaquaprojaqua.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b01f7f4d2a12d832ea9afea457ab0b3f64ab61b67875a6b2eac73ec66b9ca75f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b01f7f4d2a12d832ea9afea457ab0b3f64ab61b67875a6b2eac73ec66b9ca75f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b01f7f4d2a12d832ea9afea457ab0b3f64ab61b67875a6b2eac73ec66b9ca75f"
    sha256 cellar: :any_skip_relocation, sonoma:        "41f8bb054fd51e1cf6350d0db4d1f7903662e9c735c1e0bdcf6776fc3c0c36f0"
    sha256 cellar: :any_skip_relocation, ventura:       "41f8bb054fd51e1cf6350d0db4d1f7903662e9c735c1e0bdcf6776fc3c0c36f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7eb87d946018e3a0ca2543e8c51e343e61f8ef623d81722fa5d8de9e469ffd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdaqua"

    generate_completions_from_executable(bin"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}aqua --version")

    system bin"aqua", "init"
    assert_match "depName=aquaprojaqua-registry", (testpath"aqua.yaml").read
  end
end