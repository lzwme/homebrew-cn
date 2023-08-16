class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v3.2.1",
      revision: "fed1e441b187504a5928e2999a6210b88279139c"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32955fbf11b6316c1d6af6bb53227567d76ec5d2c2afa72893eece0c861d7be8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c00dfdde9f6e15f5adcbff029615ef21121b0a08c3c05c722287806472b8488a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45925ecaa81eebd2a4cc53d0547a0d02172b3196a281ec08d643efe9d62f0c32"
    sha256 cellar: :any_skip_relocation, ventura:        "6ad82b75e4b823e3335d3c1d2174a95b57b747d17da1fc69fba2a091dae4e98e"
    sha256 cellar: :any_skip_relocation, monterey:       "308470d3a43ce5fe69448da81d00e51c09b9d42ed299c9bf5a08619eedc305aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "29c286e8ac38c7f7b2bcc912a406b40ad480e778ee25f7d5422f35e11deacb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abbb2a4a62e5c18d4a2ecfb9c34fa98ff7d93b5275d0b288482fa65379978cd7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fugue/regula/v3/pkg/version.Version=#{version}
      -X github.com/fugue/regula/v3/pkg/version.GitCommit=#{Utils.git_short_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"regula", "completion")
  end

  test do
    (testpath/"infra/test.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    EOS

    assert_match "Found 10 problems", shell_output(bin/"regula run infra", 1)

    assert_match version.to_s, shell_output(bin/"regula version")
  end
end