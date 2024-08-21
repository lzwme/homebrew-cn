cask "blender@lts" do
  arch arm: "arm64", intel: "x64"

  version "4.2.1"
  sha256 arm:   "6d97bcc4a265c16f9376be31e178ab72768c6d18f405edfeb48dbeee49d8d3e4",
         intel: "d73ed3cea20a48e589c3cc29928392e0977f777c7c1d935b6eb76a730cddabf9"

  url "https:download.blender.orgreleaseBlender#{version.major_minor}blender-#{version}-macos-#{arch}.dmg"
  name "Blender"
  desc "Free and open-source 3D creation suite"
  homepage "https:www.blender.org"

  # NOTE: The download page contents may change once the newest version is no
  # longer an LTS version (i.e. 3.4 instead of 3.3 LTS) requiring further
  # changes to this setup.
  livecheck do
    url "https:www.blender.orgdownload"
    regex(%r{href=.*?blender[._-]v?(\d+(?:\.\d+)+)-macos-#{arch}\.dmg}i)
    strategy :page_match do |page, regex|
      # Match majorminor versions from LTS "download" page URLs
      lts_page = Homebrew::Livecheck::Strategy.page_content("https:www.blender.orgdownloadlts")
      next if lts_page[:content].blank?

      lts_versions =
        lts_page[:content].scan(%r{href=["'].*download(?:lts|releases)(\d+(?:[.-]\d+)+)["' >]}i)
                          .flatten
                          .uniq
                          .map { |v| Version.new(v) }
      next if lts_versions.blank?

      version_page = Homebrew::Livecheck::Strategy.page_content("https:www.blender.orgdownloadlts#{lts_versions.max}")
      next [] if version_page[:content].blank?

      # If the version page has a download link, return it as the livecheck version
      matched_versions = version_page[:content].scan(regex).flatten
      next matched_versions if matched_versions.present?

      # If the version page doesn't have a download link, check the download page
      # Ensure we only match LTS versions on the download page
      page.scan(regex)
          .flatten
          .select { |v| lts_versions.include?(Version.new(v).major_minor) }
    end
  end

  conflicts_with cask: "blender"
  depends_on macos: ">= :high_sierra"

  app "Blender.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}blender.wrapper.sh"
  binary shimscript, target: "blender"

  preflight do
    # make __pycache__ directories writable, otherwise uninstall fails
    FileUtils.chmod "u+w", Dir.glob("#{staged_path}*.app**__pycache__")

    File.write shimscript, <<~EOS
      #!binbash
      '#{appdir}Blender.appContentsMacOSBlender' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportBlender",
    "~LibrarySaved Application Stateorg.blenderfoundation.blender.savedState",
  ]
end