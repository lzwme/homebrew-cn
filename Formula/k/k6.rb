class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https:k6.io"
  url "https:github.comgrafanak6archiverefstagsv0.55.0.tar.gz"
  sha256 "0b32dfbafc91719bba9ffd149ddfb849270beecf3830e99708b9b6c25bf1b677"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0db449f380d7ddc588e7a0826078d9271de486f4247a46ccdfc1139cf755f9d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0db449f380d7ddc588e7a0826078d9271de486f4247a46ccdfc1139cf755f9d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0db449f380d7ddc588e7a0826078d9271de486f4247a46ccdfc1139cf755f9d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ea4ad0b8a461f8852f0c7086017465e93e07f6ffc94507ff8f410355789f717"
    sha256 cellar: :any_skip_relocation, ventura:       "0ea4ad0b8a461f8852f0c7086017465e93e07f6ffc94507ff8f410355789f717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdad18e77f5eb71aed7b40692a16b1b452e1eb8a698c9628f9d2ec87f8abaf57"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"k6", "completion")
  end

  test do
    (testpath"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}k6 version")
  end
end