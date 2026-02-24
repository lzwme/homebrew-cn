class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://ghfast.top/https://github.com/Permify/permify/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "601781e7c64a57aee8a243de54aabf4d86d1136636c793963668b7630e3f68be"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60339e3c5ed59376374fdd193411015979ccc1feb1c855148f1050510497048d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b78ecfe0eaaecb3ba49216edca1ada292166e9230cb008ac69ca781258698489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89d97761b5db05dd106836a6d9b0124510748a2055312dd6987f52bea2afe356"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc0f3a0ab5f7955b4d544996e07bc2c4e833f3de7152e89276db8c0cbd1c8d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8043145719942f9e6bb93c75beaa0f59f6fcabfa958fb22c3e41f34196a54ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58c29084d9f27637d15d633079ffef4082b75c5a390e576b71c79037280dbadf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/permify"

    generate_completions_from_executable(bin/"permify", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/permify version")

    (testpath/"schema.yaml").write <<~YAML
      schema: >-
        entity user {}

        entity document {
          relation viewer @user
          action view = viewer
        }
    YAML

    output = shell_output("#{bin}/permify ast #{testpath}/schema.yaml")
    assert_equal "document", JSON.parse(output)["entityDefinitions"]["document"]["name"]
  end
end