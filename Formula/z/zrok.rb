require "languagenode"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokarchiverefstagsv0.4.22.tar.gz"
  sha256 "ed4a19d8840d5040d7a707772de9a254d115dc7f15c05d9b3f13e19ae0d22a61"
  license "Apache-2.0"
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "628339bd21cfb8ecbe36e9be74de5e209c8bc8b5879df589f732acaf369d06d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bb6fa702a584cf7232bb9d999b230405ed596f8abf25ffd7a90224075619b1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eb0ddfcb3045687e15740f1be0a6569f06ffc123ef85a82a06b0b11fa9c1222"
    sha256 cellar: :any_skip_relocation, sonoma:         "a366e7fefbe5a198b9e1b0e1d54771c9edc226b51d82bc21b1b8814a9bd85823"
    sha256 cellar: :any_skip_relocation, ventura:        "d919471709dc60b4e555e162a724cf8f6f83a4cb9fbe7cfcee580692216cde28"
    sha256 cellar: :any_skip_relocation, monterey:       "a4b27d7db3db677460da69f9661296bfecbc5c5677200c6b647899aef004ec5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49496e954d51be82ce9d38a6306989bec817bbdab5cc52dd9405fb554b357e47"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    ldflags = ["-X github.comopenzitizrokbuild.Version=#{version}",
               "-X github.comopenzitizrokbuild.Hash=brew"]
    system "go", "build", *std_go_args(ldflags: ldflags), "github.comopenzitizrokcmdzrok"
  end

  test do
    (testpath"ctrl.yml").write <<~EOS
      v: 3
      maintenance:
        registration:
          expiration_timeout: 24h
    EOS

    version_output = shell_output("#{bin}zrok version")
    assert_match(version.to_s, version_output)
    assert_match([[a-f0-9]{40}], version_output)

    status_output = shell_output("#{bin}zrok controller validate #{testpath}ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end