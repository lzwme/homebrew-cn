class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https:k6.io"
  url "https:github.comgrafanak6archiverefstagsv0.55.2.tar.gz"
  sha256 "5d61b93a0385f5643ebc8aac883aa974dc78cae572d9f5aad4c34f128fd4b646"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9891248ebf793fe5e0bfa640ce71237567ccf079ce0bc47f9cdb6e62ff1a5f43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9891248ebf793fe5e0bfa640ce71237567ccf079ce0bc47f9cdb6e62ff1a5f43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9891248ebf793fe5e0bfa640ce71237567ccf079ce0bc47f9cdb6e62ff1a5f43"
    sha256 cellar: :any_skip_relocation, sonoma:        "03e5ac5736781944ccfbba9a76123b59d193f158a732f7b9fa507fb60c99d7cd"
    sha256 cellar: :any_skip_relocation, ventura:       "03e5ac5736781944ccfbba9a76123b59d193f158a732f7b9fa507fb60c99d7cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7be115a3f7212db4498b354bc27e299eb77db637ccb338d6113448253676e16b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"k6", "completion")
  end

  test do
    (testpath"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}k6 version")
  end
end