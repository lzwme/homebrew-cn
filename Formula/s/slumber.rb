class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://ghfast.top/https://github.com/LucasPickering/slumber/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "64435435fb27fc2dc7267fa967f333fb4c671e5c8b6ee9010bb0290834941daf"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3db808701259192626a20365e6c1ae79b07d1ba8fb99f274b7f05bf1bd192d07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94cd1696a8da4f30fe54a56be52dc942606dcc11e760703432a75c348d9f2986"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b8a87b1a824b54a6a47dee976a3bb8c20788f3910673b7e4f77ee7acf7da13b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f2e5a621c1c40217d2165ccd1a87722e1169f706d3f16a1945dc5b29f29ea17"
    sha256 cellar: :any_skip_relocation, ventura:       "c94a5212fafbd825e4209c36ce60d614188f71fc66d7a7eb912c7d857dd0dadb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0f3b2762f60d8f68eca86642941822a049382e5162477fa319bd3dc37131835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8b64e2dbaa625498af32f3d7f97cb2bb8ec6fe73ebff6224e5d8909239a686a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      # For basic usage info, see:
      # https://slumber.lucaspickering.me/book/getting_started.html
      # For all collection options, see:
      # https://slumber.lucaspickering.me/book/api/request_collection/index.html

      name: My Collection

      # Profiles are groups of data you can easily switch between. A common usage is
      # to define profiles for various environments of a REST service
      profiles:
        example:
          name: Example Profile
          data:
            host: https://httpbin.org
    YAML
  end
end