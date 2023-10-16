class Diffoci < Formula
  desc "Diff for Docker and OCI container images"
  homepage "https://github.com/reproducible-containers/diffoci"
  url "https://ghproxy.com/https://github.com/reproducible-containers/diffoci/releases/download/v0.1.2/diffoci-v0.1.2.darwin-amd64"
  sha256 "1836b1f67a29e241ff577d038bb97a7d49c206179fba78932d17cdbc912f3078"
  license "Apache-2.0"

  def install
    bin.install "diffoci-v0.1.2.darwin-amd64" => "diffoci"
  end

  test do
    system "#{bin}/diffoci", "--version"
  end
end