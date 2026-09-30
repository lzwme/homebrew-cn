class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://ghfast.top/https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "29fd5d6dc46c4cff9e0be556447bf030f38be3ea29fbde0ac0307b109f91c160"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f74c5d3e359e85027830123e20e9ae1b0342df37c9a1b9634d6e176e5d7a142e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f74c5d3e359e85027830123e20e9ae1b0342df37c9a1b9634d6e176e5d7a142e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f74c5d3e359e85027830123e20e9ae1b0342df37c9a1b9634d6e176e5d7a142e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b0b4273b318316ad9ed8aed771e555348ea79c0583435ef8a59fdd0540cc0bfa"
    sha256 cellar: :any,                 x86_64_linux:      "9217a6dfdb77b2210bf19be9a17b11f1cc0283c53dbf4e8ab2e814b54e56228c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pdfcpu"
  end

  test do
    config_file = if OS.mac?
      testpath/"Library/Application Support/pdfcpu/config.yml"
    else
      testpath/".config/pdfcpu/config.yml"
    end
    # basic config.yml
    config_file.write <<~YAML
      schemaVersion: 1
      reader15: true
      validationMode: ValidationRelaxed
      eol: EolLF
      encryptKeyLength: 256
      unit: points
    YAML

    assert_match version.to_s, shell_output("#{bin}/pdfcpu version")

    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match <<~EOS, info_output
      #{test_fixtures("test.pdf")}:
                    Source: #{test_fixtures("test.pdf")}
               PDF version: 1.6
                Page count: 1
                Page sizes: 500.00 x 800.00 points
    EOS

    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")} 2>&1")
  end
end