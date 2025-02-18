class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https:witness.dev"
  url "https:github.comin-totowitnessarchiverefstagsv0.8.0.tar.gz"
  sha256 "bdb8e29fe8a7532e8852d388cf447ee728f79c58b2de31048e4a90c6581e5bde"
  license "Apache-2.0"
  head "https:github.comin-totowitness.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f08ef50cf1b28e121099150eb3fb94d2c528118c791449a36546405b64e3a8b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f08ef50cf1b28e121099150eb3fb94d2c528118c791449a36546405b64e3a8b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f08ef50cf1b28e121099150eb3fb94d2c528118c791449a36546405b64e3a8b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc5e59c437c8f6af06f3e9b1d92263134c67b6d716029162fab4cff43afbc85e"
    sha256 cellar: :any_skip_relocation, ventura:       "fc5e59c437c8f6af06f3e9b1d92263134c67b6d716029162fab4cff43afbc85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dfdc791901fa2eeb8981b45fb9ce9134d40f1002fe3ad1e7ab2f66d0557a9c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comin-totowitnesscmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"witness", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}witness version")

    system "openssl", "genrsa", "-out", "buildkey.pem", "2048"
    system "openssl", "rsa", "-in", "buildkey.pem", "-outform", "PEM", "-pubout", "-out", "buildpublic.pem"
    system bin"witness", "run", "-s", "build", "-a", "environment", "-k", "buildkey.pem", "-o",
           "build-attestation.json"

    output = Base64.decode64(JSON.parse((testpath"build-attestation.json").read)["payload"])
    assert_match "\"type\":\"https:witness.devattestationsproductv0.1\",", output
  end
end