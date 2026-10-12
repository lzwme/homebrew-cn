class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://ghfast.top/https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "780dd9783c6f6c557d1c357b1cc51f02f525251f89aafde7c9cff864456bb396"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "784876f11ed06a708d7eaab3b3493959bae529684969f44781ac7a763c9390a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "784876f11ed06a708d7eaab3b3493959bae529684969f44781ac7a763c9390a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "784876f11ed06a708d7eaab3b3493959bae529684969f44781ac7a763c9390a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "afdf143a531a4e9ac6a57123772a0fe74cccbef7865ee6140e31ab3cc2363a18"
    sha256 cellar: :any,                 x86_64_linux:      "3b600c70b4c785df9a38115e6546800219921b91e3a7a5d78c18982e3c706609"
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