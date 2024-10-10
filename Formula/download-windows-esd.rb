class DownloadWindowsEsd < Formula
  desc "Download Windows 11 ESDs directly from Microsoft"
  homepage "https:github.commattiebdownload-windows-esd"
  url "https:github.commattiebdownload-windows-esdarchivef744452d082bf6539caa8202cd16b016ff390435.tar.gz"
  version "2024-07-07"
  sha256 "40bfeb3d2efa18949988dfca0d9be38ec732a7c2742be7a39adcfc5e6023cdec"
  license "MIT"

  patch do
    # url "https:github.commattiebdownload-windows-esdpull4"
    url "https:github.commattiebdownload-windows-esdcommit104bed89ed6c5075d55db715cbc41056b8ef7e48.patch?full_index=1"
    sha256 "e19d9f7c41ef996d971278d639756665636999d11384084f40774d5540fcf735"
  end

  def install
    bin.install "download-windows-esd"
  end
end