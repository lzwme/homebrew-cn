class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https:k6.io"
  url "https:github.comgrafanak6archiverefstagsv0.57.0.tar.gz"
  sha256 "75ccb3f7a9d3c2045d71b9bbb37d8a5e1b482b374d5c3deedac4523700a5bf05"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fa3ba542358442f674abadf5311b3df139b231ef936d22ec1353f892c68d8d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fa3ba542358442f674abadf5311b3df139b231ef936d22ec1353f892c68d8d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fa3ba542358442f674abadf5311b3df139b231ef936d22ec1353f892c68d8d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fa3ca23db747428df4052d2b63e7feceb63a6e75f8a4b279c8772e7841c4157"
    sha256 cellar: :any_skip_relocation, ventura:       "4fa3ca23db747428df4052d2b63e7feceb63a6e75f8a4b279c8772e7841c4157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24567bec8c95d994fe68af10802d02fee986c31d95c8e00643f31d8c07453da0"
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